
module TopModule (
    input wire [5:0] y,
    input wire w,
    output reg Y1,
    output reg Y3
);

    
    reg [1:0] state;

    
    always @(posedge w or posedge y) begin
        if (w) begin
            case (state)
                2'b00: state <= 2'b01;
                2'b01: state <= 2'b10;
                2'b10: state <= 2'b11;
                2'b11: state <= 2'b00;
                default: state <= 2'b00;
            endcase
        end else begin
            case (state)
                2'b00: state <= 2'b00;
                2'b01: state <= 2'b01;
                2'b10: state <= 2'b10;
                2'b11: state <= 2'b11;
                default: state <= 2'b00;
            endcase
        end
    end

    
    assign Y1 = state[1];
    assign Y3 = state[3];

endmodule
