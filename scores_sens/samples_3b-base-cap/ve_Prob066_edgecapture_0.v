
module TopModule (
    input  clk,
    input  reset,
    input  [31:0] in,
    output [31:0] out
);

    
    reg [1:0] state;
    reg [31:0] prev_in;

    
    reg [31:0] captured_value;

    
    initial begin
        state = 2'b00;
 
        prev_in = 32'b0;
        captured_value = 32'b0;
    end

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= 2'b00;
 
            prev_in <= 32'b0;
            captured_value <= 32'b0;
        end else begin
            case (state)
                2'b00: begin 
                    if (in != prev_in) begin
                        state <= 2'b01;
 
                        captured_value <= in;
                    end
                end
                2'b01: begin 
                    if (reset) begin
                        state <= 2'b00;
 
                        prev_in <= 32'b0;
                        captured_value <= 32'b0;
                    end
                end
            endcase
        end
    end

    
    assign out = captured_value;

endmodule
