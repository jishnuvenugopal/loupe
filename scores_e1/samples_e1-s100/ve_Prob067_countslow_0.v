
module TopModule (
    input clk,
    input reset,
    input slowena,
    output reg [3:0] q
);

    
    reg [3:0] counter;
    reg [0:0] reset_counter;
    reg [0:0] clk_counter;

    
    reg [0:0] enable_counter;

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            reset_counter <= 1'b1;
            clk_counter <= 1'b0;
            counter <= 4'b0000;
        end else begin
            clk_counter <= clk_counter + 1'b1;
            if (clk_counter == 4'b1001) begin
                clk_counter <= 1'b0;
                counter <= counter + 1'b1;
            end
        end
    end

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            enable_counter <= 1'b0;
        end else begin
            enable_counter <= slowena;
        end
    end

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            q <= 4'b0000;
        end else begin
            q <= counter;
        end
    end

endmodule
