
module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire j,
    input  wire k,
    output wire out
);

    
    reg [1:0] state;

    
    assign out = state[1];

    always @(posedge clk or posedge reset) begin
        if (reset)
            state <= 2'b00;
 
        else begin
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
 
                default: state <= 2'b00;
 
            endcase
        end
    end

endmodule
