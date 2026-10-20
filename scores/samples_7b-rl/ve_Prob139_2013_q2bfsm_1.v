
module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output f,
    output reg g
);

    
    localparam S_A = 0;
    localparam S_F = 1;
    localparam S_X = 2;
    localparam S_G = 3;
    localparam S_Y = 4;
    localparam S_WAIT1 = 5;
    localparam S_WAIT2 = 6;

    reg [2:0] state, next_state;
    reg [1:0] x_history;
 

    
    

    
    assign f = (state == S_F);

    
    always @(posedge clk or negedge resetn) begin
        if (!resetn) state <= S_A;
        else state <= next_state;
    end

    
    always @(*) begin
        case (state)
            S_A: next_state = (resetn) ? S_F : S_A;

            S_F: next_state = S_X;

            S_X: begin
                if (x_history == 3'b101 && state == S_X) begin
                    next_state = S_G;
                end else begin
                    next_state = S_X;
                    
                    x_history = {x_history[1:0], x};
                end
            end

            S_G: next_state = S_Y;
 

            S_Y: begin
                
                if (y) begin
                    next_state = S_G;
 
                end else begin
                    next_state = S_WAIT1;
                end
            end

            S_WAIT1: begin
                if (y) begin
                    next_state = S_G;
                end else begin
                    next_state = S_WAIT2;
                end
            end

            S_WAIT2: next_state = S_G;
 

            default: next_state = S_A;
        endcase
    end

    
    always @(posedge clk or negedge resetn) begin
        if (!resetn) begin
            g <= 0;
            x_history <= 0;
            state <= S_A;
        end else begin
            case (state)
                S_A: if (resetn) begin
                    state <= S_F;
                    g <= 0;
                end

                S_F: begin
                    g <= 0;
                    x_history <= 0;
                end

                S_X: x_history <= {x_history[1:0], x};

                S_G: g <= 1;

                S_Y: if (!y) g <= 1;

                S_WAIT1: if (!y) g <= 1;

                S_WAIT2: ;
 
            endcase
        end
    end
endmodule
