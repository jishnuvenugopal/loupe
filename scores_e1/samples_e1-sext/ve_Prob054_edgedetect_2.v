
module TopModule (
    input clk,
    input [7:0] in,
    output reg pedge
);

    
    reg [2:0] count;

    
    enum reg [1:0] {IDLE, COUNTING} state;

    always @(posedge clk) begin
        case (state)
            IDLE: begin
                if (in == 8'b0) begin
                    count = 3'b000;
                    state = COUNTING;
                end
            end
            COUNTING: begin
                if (in == 8'b1) begin
                    count = 3'b000;
                    state = IDLE;
                    pedge = 1'b1;
                end else begin
                    count = count + 1'b1;
                end
            end
        endcase
    end

endmodule
