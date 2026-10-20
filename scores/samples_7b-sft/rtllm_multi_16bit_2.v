
module multi_16bit (
    input clk,
    input rst_n,
    input start,
    input [15:0] ain,
    input [15:0] bin,
    output [31:0] yout,
    output reg done
);

    reg [4:0] i;
 
    reg [15:0] areg;
 
    reg [15:0] breg;
 
    reg [31:0] yout_r;
 

    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            i <= 5'd0;
        end else begin
            if (start) begin
                if (i < 5'd17)
                    i <= i + 1;
                else
                    i <= i;
            end else begin
                i <= 5'd0;
            end
        end
    end

    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            done <= 1'b0;
        end else begin
            if (i == 5'd16)
                done <= 1'b1;
            else if (i == 5'd17)
                done <= 1'b0;
            else
                done <= done;
        end
    end

    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            areg <= 16'b0;
            breg <= 16'b0;
            yout_r <= 32'b0;
        end else begin
            if (start) begin
                if (i == 5'd0) begin
                    areg <= ain;
                    breg <= bin;
                end else if (i >= 5'd1 && i < 5'd17) begin
                    if (areg[i-1]) begin
                        yout_r <= yout_r + (breg << (i-1));
                    end
                end
            end
        end
    end

    assign yout = yout_r;

endmodule
