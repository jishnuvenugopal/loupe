
module TopModule (
    input  clk,
    input  reset,
    input  j,
    input  k,
    output out
);

    
    localparam OFF = 1'b0;
    localparam ON  = 1'b1;

    
    reg state;

    
    assign out = state;

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= OFF;
  
        end else begin
            case (state)
                OFF:
                    if (j) state <= ON;
                ON:
                    if (k) state <= OFF;
                default: state <= OFF;
  
            endcase
        end
    end

endmodule
