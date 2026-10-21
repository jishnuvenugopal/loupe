
module TopModule (
    input clk,
    input ar,
    input d,
    output q
);

    
    reg [1:0] state;

    
    always @(posedge clk or posedge ar) begin
        if (ar) begin
            state <= 2'b00;
 
        end else begin
            case (state)
                2'b00: state <= 2'b01;
 
                2'b01: state <= 2'b00;
 
                default: state <= 2'b00;
 
            endcase
        end
    end

    
    assign q = state[0];

endmodule
