
module TopModule (
    input  clk,
    input  load,
    input  [1:0] ena,
    input  [99:0] data,
    output reg [99:0] q
);

    
    reg [99:0] reg_q;

    
    always @(posedge clk) begin
        if (load) begin
            reg_q <= data;
        end
    end

    
    always @(posedge clk) begin
        case (ena)
            2'b01: begin 
                reg_q[99] <= reg_q[98];
                for (int i = 98;
 i >= 0;
 i--) begin
                    reg_q[i] <= reg_q[i - 1];
                end
            end
            2'b10: begin 
                reg_q[0] <= reg_q[1];
                for (int i = 1;
 i <= 99;
 i++) begin
                    reg_q[i] <= reg_q[i + 1];
                end
            end
            default: begin 
                
            end
        endcase
    end

    
    assign q = reg_q;

endmodule
