
module TopModule (
    input clk,
    input areset,
    input j,
    input k,
    output out
);

    
    typedef enum reg [1:0] {
        OFF = 2'b00,
        ON = 2'b01
    } state_t, next_state_t;

    
    state_t current_state, next_state;

    
    always @(*) begin
        case (current_state)
            OFF:
                begin
                    if (j)
                        next_state = ON;
                    else
                        next_state = OFF;
                end
            ON:
                begin
                    if (k)
                        next_state = OFF;
                    else
                        next_state = ON;
                end
            default:
                next_state = OFF;
 
        endcase
    end

    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            current_state <= OFF;
        end else begin
            current_state <= next_state;
        end
    end

    
    assign out = (current_state == ON);

endmodule
