
module TopModule (
    input clk,
    input reset,
    input s,
    input w,
    output z
);

    parameter A = 2'b00,
              B = 2'b01,
              Z_SET = 2'b10;

    reg [1:0] current_state, next_state;
    reg [1:0] count;
    reg [1:0] sum;

    always @(posedge clk) begin
        if (reset) begin
            current_state <= A;
            count <= 0;
            sum <= 0;
        end else begin
            current_state <= next_state;
            case (current_state)
                A: begin
                    if (s) begin
                        count <= 0;
                        sum <= 0;
                    end else begin
                        count <= 0;
                        sum <= 0;
                    end
                end
                B: begin
                    count <= count + 1;
                    sum <= sum + w;
                end
                Z_SET: begin
                    count <= 0;
                    sum <= 0;
                end
                default: begin
                    count <= 0;
                    sum <= 0;
                end
            endcase
        end
    end

    always @* begin
        case (current_state)
            A: next_state = s ? B : A;
            B: begin
                if (count == 2) next_state = (sum == 2) ? Z_SET : B;
                else next_state = B;
            end
            Z_SET: next_state = B;
            default: next_state = A;
        endcase
    end

    assign z = (current_state == Z_SET);

endmodule
