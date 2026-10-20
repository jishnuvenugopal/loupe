
module TopModule(
    input wire clk,
    input wire reset,
    input wire in,
    output reg out
);


localparam B = 1'b0;
localparam A = 1'b1;


reg state;


reg out_reg;


always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= B;
        out_reg <= 1'b1;
 
    end else begin
        case (state)
            B: begin
                if (in == 1'b0)
                    state <= A;
                else
                    state <= B;
            end
            A: begin
                if (in == 1'b0)
                    state <= B;
                else
                    state <= A;
            end
            default: state <= B;
 
        endcase
    end
end


always @(*) begin
    case (state)
        B: out_reg = 1'b1;
        A: out_reg = 1'b0;
        default: out_reg = 1'b1;
 
    endcase
end


assign out = out_reg;

endmodule
