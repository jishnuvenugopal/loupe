
module TopModule (
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

    reg [2:0] state;
    reg [1:0] stored_count;

    localparam A = 3'b000;
    localparam B = 3'b001;
    localparam B1 = 3'b010;
    localparam B2 = 3'b011;
    localparam B3 = 3'b100;

    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            stored_count <= 2'b00;
            z <= 1'b0;
        end else begin
            case (state)
                A: begin
                    if (s) begin
                        state <= B;
                    end
                    stored_count <= 2'b00;
                    z <= 1'b0;
                end
                B: begin
                    state <= B1;
                    stored_count <= 2'b00;
                end
                B1: begin
                    state <= B2;
                    stored_count <= w ? 2'b01 : 2'b00;
                end
                B2: begin
                    state <= B3;
                    stored_count <= stored_count + (w ? 2'b01 : 2'b00);
                end
                B3: begin
                    state <= B;
                    stored_count <= stored_count + (w ? 2'b01 : 2'b00);
                end
                default: state <= A;
            endcase

            if (state == B) begin
                z <= (stored_count == 2'b10);
            end else begin
                z <= 1'b0;
            end
        end
    end

endmodule
