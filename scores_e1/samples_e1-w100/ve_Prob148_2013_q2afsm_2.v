
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
                    end else if (r[1] == 1) begin
                        state <= 2'b02;
                    end else if (r[2] == 1) begin
                        state <= 2'b00;
                    end
                end
                2'b01: begin
                    g[0] <= 1;
                    state <= 2'b00;
                end
                2'b02: begin
                    g[1] <= 1;
                    state <= 2'b00;
                end
            endcase
        end
    end

endmodule
