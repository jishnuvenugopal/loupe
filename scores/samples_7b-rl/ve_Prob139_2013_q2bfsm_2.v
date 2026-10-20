
module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

    reg [2:0] state;
    reg [2:0] shift_reg;
    reg [1:0] counter;

    
    localparam S_RESET    = 3'd0,
               S_F_ACTIVE = 3'd1,
               S_F_INACT  = 3'd2,
               S_X_DETECT = 3'd3,
               S_G_ACTIVE = 3'd4,
               S_WAIT1    = 3'd5,
               S_WAIT2    = 3'd6;

    
    always @(posedge clk) begin
        if (!resetn)
            shift_reg <= 3'b0;
        else if (state == S_X_DETECT)
            shift_reg <= { shift_reg[1:0], x };
    end

    
    always @(posedge clk) begin
        if (!resetn) begin
            state <= S_RESET;
            f <= 0;
            g <= 0;
            counter <= 0;
        end
        else begin
            case (state)
                S_RESET: begin
                    f <= 0;
                    g <= 0;
                    if (resetn) begin
                        state <= S_F_ACTIVE;
                        f <= 1;
                    end
                end

                S_F_ACTIVE: begin
                    f <= 0;
                    state <= S_F_INACT;
                end

                S_F_INACT: begin
                    counter <= 2;
                    state <= S_X_DETECT;
                end

                S_X_DETECT: begin
                    if (shift_reg == 3'b101) begin
                        state <= S_G_ACTIVE;
                        g <= 1;
                    end
                    else begin
                        state <= S_F_INACT;
                    end
                end

                S_G_ACTIVE: begin
                    if (counter > 0) begin
                        counter <= counter - 1;
                        if (y) state <= S_G_ACTIVE;
                        else state <= (counter == 1) ? S_WAIT2 : S_WAIT1;
                    end
                    else if (y) state <= S_G_ACTIVE;
                    else state <= S_RESET;
                end

                S_WAIT1: begin
                    if (y) state <= S_G_ACTIVE;
                    else begin
                        counter <= 1;
                        state <= S_WAIT2;
                    end
                end

                S_WAIT2: begin
                    if (y) state <= S_G_ACTIVE;
                    else state <= S_RESET;
                end

                default: state <= S_RESET;
            endcase
        end
    end

endmodule
