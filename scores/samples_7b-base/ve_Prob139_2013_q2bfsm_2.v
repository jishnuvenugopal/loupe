
module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

    
    parameter A = 2'b00;
    parameter B = 2'b01;
    parameter C = 2'b10;
    parameter D = 2'b11;

    reg [1:0] state, next_state;

    
    reg [1:0] x_sequence;

    
    reg [1:0] y_counter;

    
    always @(posedge clk or negedge resetn) begin
        if (!resetn) begin
            state <= A;
            f <= 0;
            g <= 0;
            x_sequence <= 2'b00;
            y_counter <= 2'b00;
        end else begin
            state <= next_state;
            if (state == B && f == 1) begin
                f <= 0;
            end
            if (state == C) begin
                if (y == 1) begin
                    g <= 1;
                end else if (y_counter == 2'b01) begin
                    g <= 0;
                end else begin
                    y_counter <= y_counter + 1;
                end
            end
        end
    end

    
    always @(*) begin
        next_state = state;
        f = 0;
        g = 0;
        y_counter = 0;

        case (state)
            A: begin
                if (x == 1) begin
                    next_state = B;
                    f = 1;
                end
            end
            B: begin
                f = 0;
                if (x_sequence == 2'b111) begin
                    next_state = C;
                end else begin
                    y_sequence = (y_sequence << 1) | x;
                end
            end
            C: begin
                if (y == 1) begin
                    next_state = C;
                    g = 1;
                end else if (y_counter == 2'b01) begin
                    next_state = C;
                    g = 0;
                end else begin
                    y_counter = y_counter + 1;
                    next_state = C;
                end
            end
            default: begin
                next_state = A;
            end
        endcase
    end

endmodule
