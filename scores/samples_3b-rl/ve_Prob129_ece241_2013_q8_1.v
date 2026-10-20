
module TopModule (
    input  wire clk,
    input  wire aresetn,
    input  wire x,
    output reg  z
);

    
    typedef enum {IDLE, X1, X0} state_t;
    state_t state;

    
    reg z_reg;

    
    always @(*) begin
        case (state)
            IDLE:  z = (x == 1'b1) ? 1'b1 : 1'b0;
            X1:    z = (x == 1'b0) ? 1'b1 : 1'b0;
            X0:    z = (x == 1'b1) ? 1'b1 : 1'b0;
            default: z = 1'b0;
        endcase
    end

    
    always @(posedge clk or negedge aresetn) begin
        if (!aresetn)
            state <= IDLE;
        else begin
            case (state)
                IDLE:  if (x == 1'b1) state <= X1;
                X1:    if (x == 1'b0) state <= X0;
                X0:    if (x == 1'b1) state <= X1;
                default: state <= IDLE;
            endcase
        end
    end

    
    always @(posedge clk or negedge aresetn) begin
        if (!aresetn)
            z_reg <= 1'b0;
        else
            z_reg <= z;
    end

    assign z = z_reg;

endmodule
