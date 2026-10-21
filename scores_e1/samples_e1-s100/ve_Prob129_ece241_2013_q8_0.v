
module TopModule (
    input clk,
    input aresetn,
    input x,
    output reg z
);

    
    typedef enum {idle, detecting_1, detecting_01} state_t;

    
    state_t state = idle;

    
    always @(posedge clk or posedge aresetn) begin
        if (aresetn) begin
            state <= idle;
            z <= 0;
        end else begin
            case (state)
                idle: begin
                    if (x == 1) begin
                        state <= detecting_1;
                    end
                end
                detecting_1: begin
                    if (x == 0) begin
                        state <= detecting_01;
                    end
                end
                detecting_01: begin
                    if (x == 1) begin
                        state <= detecting_1;
                    end
                end
            endcase
        end
    end

    
    always @(posedge clk or posedge aresetn) begin
        if (aresetn) begin
            z <= 0;
        end else begin
            z <= (state == detecting_1) || (state == detecting_01);
        end
    end

endmodule
