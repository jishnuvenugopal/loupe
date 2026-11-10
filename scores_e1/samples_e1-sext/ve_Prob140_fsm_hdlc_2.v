
module TopModule (
    input clk,
    input reset,
    input in,
    output reg disc,
    output reg flag,
    output reg err
);

    
    reg [2:0] state;
    reg [1:0] count;

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= 3'b000;
            count <= 2'b00;
        end else begin
            case (state)
                3'b000: begin
                    if (in == 1) begin
                        count <= count + 1;
                    end else begin
                        count <= 2'b00;
                    end
                    if (count == 5) begin
                        state <= 3'b001;
                    end
                end
                3'b001: begin
                    if (in == 1) begin
                        count <= count + 1;
                    end else begin
                        count <= 2'b00;
                    end
                    if (count == 6) begin
                        state <= 3'b010;
                    end
                end
                3'b010: begin
                    if (in == 1) begin
                        count <= count + 1;
                    end else begin
                        count <= 2'b00;
                    end
                    if (count == 7) begin
                        state <= 3'b011;
                    end
                end
                3'b011: begin
                    if (in == 1) begin
                        count <= count + 1;
                    end else begin
                        count <= 2'b00;
                    end
                    if (count == 8) begin
                        state <= 3'b100;
                    end
                end
                3'b100: begin
                    if (in == 1) begin
                        count <= count + 1;
                    end else begin
                        count <= 2'b00;
                    end
                    if (count == 9) begin
                        state <= 3'b101;
                    end
                end
                3'b101: begin
                    if (in == 1) begin
                        count <= count + 1;
                    end else begin
                        count <= 2'b00;
                    end
                    if (count == 10) begin
                        state <= 3'b110;
                    end
                end
                3'b110: begin
                    if (in == 1) begin
                        count <= count + 1;
                    end else begin
                        count <= 2'b00;
                    end
                    if (count == 11) begin
                        state <= 3'b111;
                    end
                end
                3'b111: begin
                    if (in == 1) begin
                        count <= count + 1;
                    end else begin
                        count <= 2'b00;
                    end
                    if (count == 12) begin
                        state <= 3'b000;
                    end
                end
                default: begin
                    state <= 3'b000;
                    count <= 2'b00;
                end
            endcase
        end
    end

    
    assign disc = (state == 3'b001);
    assign flag = (state == 3'b010);
    assign err = (state == 3'b111);

endmodule
