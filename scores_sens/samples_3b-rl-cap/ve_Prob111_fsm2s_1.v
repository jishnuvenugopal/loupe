
module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire j,
    input  wire k,
    output reg  out
);

    
    reg [1:0] state;

    always @(posedge clk) begin
        if (reset) begin
            state <= 2'b00;
 
        end else begin
            case (state)
                2'b00: 
                    if (j) begin
                        state <= 2'b10;
 
                    end else begin
                        state <= 2'b00;
 
                    end
                2'b01: 
                    state <= 2'b00;
 
                2'b10: 
                    if (j) begin
                        state <= 2'b11;
 
                    end else begin
                        state <= 2'b00;
 
                    end
                2'b11: 
                    if (k) begin
                        state <= 2'b11;
 
                    end else begin
                        state <= 2'b00;
 
                    end
                default: 
                    state <= 2'b00;
 
            endcase
        end
    end

    
    assign out = state[1];

endmodule
