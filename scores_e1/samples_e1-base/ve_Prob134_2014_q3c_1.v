
module TopModule (
    input wire x,
    input wire [2:0] y,
    output reg Y0,
    output reg z
);

    
    typedef enum {S0, S1, S2, S3} FSMState;

    
    FSMState current_state;

    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            current_state <= S0;
            Y0 <= 0;
            z <= 0;
        end else begin
            case (current_state)
                S0: begin
                    if (x == 0) begin
                        current_state <= S0;
                        Y0 <= y[0];
                        z <= 0;
                    end else begin
                        current_state <= S1;
                        Y0 <= y[0];
                        z <= 0;
                    end
                end
                S1: begin
                    if (x == 0) begin
                        current_state <= S2;
                        Y0 <= y[0];
                        z <= 0;
                    end else begin
                        current_state <= S3;
                        Y0 <= y[0];
                        z <= 0;
                    end
                end
                S2: begin
                    if (x == 0) begin
                        current_state <= S0;
                        Y0 <= y[0];
                        z <= 0;
                    end else begin
                        current_state <= S1;
                        Y0 <= y[0];
                        z <= 0;
                    end
                end
                S3: begin
                    if (x == 0) begin
                        current_state <= S2;
                        Y0 <= y[0];
                        z <= 0;
                    end else begin
                        current_state <= S3;
                        Y0 <= y[0];
                        z <= 0;
                    end
                end
            endcase
        end
    end

endmodule
