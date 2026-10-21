
module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

    
    typedef enum {A, B, C} state_t;
    state_t state;

    
    reg [1:0] x_count;
    reg [1:0] y_count;

    
    always @(posedge clk or negedge resetn) begin
        if (!resetn) begin
            state <= A;
            x_count <= 2'b00;
            y_count <= 2'b00;
            f <= 1'b0;
            g <= 1'b0;
        end else begin
            case (state)
                A: begin
                    if (x_count == 3'b111) begin
                        state <= B;
                        x_count <= 2'b00;
                        y_count <= 2'b00;
                        f <= 1'b1;
                        g <= 1'b0;
                    end else begin
                        x_count <= x_count + 1'b1;
                    end
                end
                B: begin
                    if (x == 1'b1) begin
                        x_count <= 2'b00;
                        y_count <= 2'b00;
                        f <= 1'b1;
                        g <= 1'b0;
                    end else if (x == 1'b0) begin
                        x_count <= x_count + 1'b1;
                    end else if (x == 1'b1) begin
                        x_count <= 2'b00;
                        y_count <= 2'b00;
                        f <= 1'b1;
                        g <= 1'b0;
                    end else begin
                        x_count <= x_count + 1'b1;
                    end
                end
                C: begin
                    if (y == 1'b1) begin
                        g <= 1'b1;
                    end else begin
                        g <= 1'b0;
                    end
                end
            endcase
        end
    end

endmodule
