
module TopModule (
    input wire x,
    input wire [2:0] y,
    output reg Y0,
    output reg z
);

    
    typedef enum {State000, State001, State010, State011} FSMState;

    
    FSMState currentState;

    
    always @(posedge clk or negedge rst) begin
        if (rst) begin
            currentState <= State000;
            Y0 <= 0;
            z <= 0;
        end else begin
            case (currentState)
                State000: begin
                    if (x == 0) begin
                        currentState <= State001;
                        Y0 <= 0;
                        z <= 0;
                    end else begin
                        currentState <= State000;
                        Y0 <= 0;
                        z <= 0;
                    end
                end
                State001: begin
                    if (x == 0) begin
                        currentState <= State001;
                        Y0 <= 0;
                        z <= 0;
                    end else begin
                        currentState <= State010;
                        Y0 <= 0;
                        z <= 0;
                    end
                end
                State010: begin
                    if (x == 0) begin
                        currentState <= State010;
                        Y0 <= 0;
                        z <= 0;
                    end else begin
                        currentState <= State011;
                        Y0 <= 0;
                        z <= 0;
                    end
                end
                State011: begin
                    if (x == 0) begin
                        currentState <= State011;
                        Y0 <= 0;
                        z <= 0;
                    end else begin
                        currentState <= State000;
                        Y0 <= 0;
                        z <= 0;
                    end
                end
            endcase
        end
    end

endmodule
