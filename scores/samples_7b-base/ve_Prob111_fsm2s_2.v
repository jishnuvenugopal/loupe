
module TopModule (
    input wire clk,
    input wire reset,
    input wire j,
    input wire k,
    output reg out
);


localparam OFF = 0;
localparam ON = 1;


reg [1:0] state;


always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= OFF;
        out <= 0;
    end else begin
        case (state)
            OFF: begin
                out <= 0;
                if (j) state <= ON;
            end
            ON: begin
                out <= 1;
                if (k) state <= OFF;
            end
            default: state <= OFF;
 
        endcase
    end
end

endmodule
