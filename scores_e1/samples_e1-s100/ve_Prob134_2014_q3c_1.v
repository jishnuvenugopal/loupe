
module TopModule (
    input wire x,
    input wire [2:0] y,
    output reg Y0,
    output reg z
);

    
    typedef enum {State000, State001, State010, State011} FSMState;

    
    FSMState current_state;

    
    always @(posedge clk or negedge rst) begin
        if (rst) begin
            current_state <= State000;
            Y0 <= 0;
            z <= 0;
        end else begin
            case (current_state)
                State000: begin
                    if (x == 0) begin
                        current_state <= State001;
                        Y0 <= y[0];
                        z <= 0;
                    end else begin
                        current_state <= State010;
                        Y0 <= y[0];
                        z <= 0;
                    end
                end
                State001: begin
                    if (x == 0) begin
                        current_state <= State001;
                        Y0 <= y[0];
                        z <= 0;
                    end else begin
                        current_state <= State011;
                        Y0 <= y[0];
                        z <= 0;
                    end
                end
                State010: begin
                    if (x == 0) begin
                        current_state <= State010;
                        Y0 <= y[0];
                        z <= 0;
                    end else begin
                        current_state <= State011;
                        Y0 <= y[0];
                        z <= 0;
                    end
                end
                State011: begin
                    if (x == 0) begin
                        current_state <= State011;
                        Y0 <= y[0];
                        z <= 1;
                    end else begin
                        current_state <= State000;
                        Y0 <= y[0];
                        z <= 1;
                    end
                end
            endcase
        end
    end

endmodule
