
module TopModule (
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

    reg [1:0] state;
    reg [1:0] counter;
    reg [2:0] shift_reg;
    reg [1:0] count_reg;

    localparam A = 2'b00;
    localparam B = 2'b01;

    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            counter <= 0;
            shift_reg <= 3'b0;
            count_reg <= 0;
        end else begin
            case (state)
                A: begin
                    if (s) begin
                        state <= B;
                        counter <= 0;
                        shift_reg <= {shift_reg[1:0], w};
                    end else begin
                        state <= A;
                    end
                end
                B: begin
                    shift_reg <= {shift_reg[1:0], w};
                    if (counter == 2) begin
                        counter <= 0;
                    end else begin
                        counter <= counter + 1;
                    end
                end
            endcase
        end
    end

    always @(posedge clk) begin
        if (reset) begin
            count_reg <= 0;
        end else if (state == B && counter == 2) begin
            count_reg <= ({shift_reg[1:0], w}[0] + {shift_reg[1:0], w}[1] + {shift_reg[1:0], w}[2]);
        end else begin
            count_reg <= count_reg;
        end
    end

    always @(posedge clk) begin
        if (reset) begin
            z <= 0;
        end else begin
            z <= (state == B) && (count_reg == 2);
        end
    end

endmodule
