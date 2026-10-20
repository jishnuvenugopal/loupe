
module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire j,
    input  wire k,
    output wire out
);

    
    reg [1:0] state;

    
    assign out = state[1];

    always @(posedge clk) begin
        if (reset) begin
            state <= 2'b00;
 
        end else begin
            case (state)
                2'b00: begin 
                    if (j) begin
                        state <= 2'b01;
 
                    end else begin
                        state <= 2'b00;
 
                    end
                end
                2'b01: begin 
                    if (k) begin
                        state <= 2'b00;
 
                    end else begin
                        state <= 2'b01;
 
                    end
                end
                default: begin
                    state <= 2'b00;
 
                end
            endcase
        end
    end

endmodule
