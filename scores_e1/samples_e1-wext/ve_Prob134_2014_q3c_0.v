
module TopModule (
    input wire x,
    input wire [2:0] y,
    output reg Y0,
    output reg z
);

    
    reg [2:0] state;

    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= 3'b000;
            Y0 <= 1'b0;
            z <= 1'b0;
        end else begin
            case (state)
                3'b000: begin
                    if (x == 1'b0) begin
                        state <= 3'b001;
                        Y0 <= 1'b0;
                        z <= 1'b0;
                    end else begin
                        state <= 3'b000;
                        Y0 <= 1'b0;
                        z <= 1'b0;
                    end
                end
                3'b001: begin
                    if (x == 1'b0) begin
                        state <= 3'b001;
                        Y0 <= 1'b0;
                        z <= 1'b0;
                    end else begin
                        state <= 3'b010;
                        Y0 <= 1'b0;
                        z <= 1'b0;
                    end
                end
                3'b010: begin
                    if (x == 1'b0) begin
                        state <= 3'b010;
                        Y0 <= 1'b0;
                        z <= 1'b0;
                    end else begin
                        state <= 3'b010;
                        Y0 <= 1'b0;
                        z <= 1'b0;
                    end
                end
                3'b011: begin
                    if (x == 1'b0) begin
                        state <= 3'b011;
                        Y0 <= 1'b0;
                        z <= 1'b0;
                    end else begin
                        state <= 3'b001;
                        Y0 <= 1'b0;
                        z <= 1'b0;
                    end
                end
                3'b100: begin
                    if (x == 1'b0) begin
                        state <= 3'b100;
                        Y0 <= 1'b0;
                        z <= 1'b0;
                    end else begin
                        state <= 3'b100;
                        Y0 <= 1'b0;
                        z <= 1'b0;
                    end
                end
            endcase
        end
    end

    
    assign Y0 = state[0];
    assign z = state[2];

endmodule
