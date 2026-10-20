
module TopModule (
    input clk,
    input areset,
    input j,
    input k,
    output out
);

    
    reg [1:0] state;

    
    assign out = state[0];

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 2'b00;
 
        end else begin
            case (state)
                2'b00: 
                    if (j)
                        state <= 2'b01;
 
                    else
                        state <= 2'b00;
 
                2'b01: 
                    if (k)
                        state <= 2'b00;
 
                    else
                        state <= 2'b01;
 
                default:
                    state <= 2'b00;
 
            endcase
        end
    end

endmodule
