
module TopModule (
    input clk,
    input resetn,
    input [2:0] r,
    output reg [2:0] g
);

    
    reg [1:0] state;

    
    always @(posedge clk or posedge resetn) begin
        if (resetn) begin
            state <= 2'b00;
        end else begin
            case (state)
                2'b00: begin
                    if (r[0] == 1) begin
                        state <= 2'b01;
                    end else if (r[0] == 0 && r[1] == 1) begin
                        state <= 2'b02;
                    end else if (r[0] == 0 && r[1] == 0 && r[2] == 0) begin
                        state <= 2'b03;
                    end
                end
                2'b01: begin
                    state <= 2'b01;
                end
                2'b02: begin
                    state <= 2'b02;
                end
                2'b03: begin
                    state <= 2'b03;
                end
                default: begin
                    state <= 2'b00;
                end
            endcase
        end
    end

    
    always @(posedge clk or posedge resetn) begin
        if (resetn) begin
            g <= 3'b000;
        end else begin
            case (state)
                2'b00: begin
                    g <= 3'b000;
                end
                2'b01: begin
                    g <= 3'b001;
                end
                2'b02: begin
                    g <= 3'b010;
                end
                2'b03: begin
                    g <= 3'b011;
                end
                default: begin
                    g <= 3'b000;
                end
            endcase
        end
    end

endmodule
