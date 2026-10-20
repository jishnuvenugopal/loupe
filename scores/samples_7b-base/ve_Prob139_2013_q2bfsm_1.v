
module TopModule(clk, resetn, x, y, f, g);
    input wire clk, resetn, x, y;
    output reg f, g;

    
    parameter A = 3'b000,
              B = 3'b001,
              C = 3'b010,
              D = 3'b011,
              E = 3'b100,
              F = 3'b101;

    reg [2:0] state;
    reg [1:0] x_counter;
 
    reg [1:0] y_counter;
 

    always @(posedge clk or negedge resetn) begin
        if (!resetn) begin
            
            state <= A;
            x_counter <= 2'b00;
            y_counter <= 2'b00;
            f <= 0;
            g <= 0;
        end else begin
            case (state)
                A: begin
                    x_counter <= 2'b00;
                    y_counter <= 2'b00;
                    f <= 0;
                    g <= 0;
                    if (x == 1'b1) begin
                        state <= B;
                    end
                end
                B: begin
                    x_counter <= 2'b00;
                    y_counter <= 2'b00;
                    f <= 1;
                    g <= 0;
                    state <= C;
                end
                C: begin
                    if (x == 1'b1) begin
                        x_counter <= 2'b01;
                    end else if (x == 1'b0) begin
                        x_counter <= 2'b10;
                    end else if (x == 1'b1 && y == 1'b1) begin
                        g <= 1;
                        state <= D;
                    end else begin
                        x_counter <= 2'b00;
                        state <= C;
                    end
                end
                D: begin
                    if (y == 1'b1) begin
                        y_counter <= 2'b01;
                    end else begin
                        y_counter <= 2'b00;
                    end
                    if (y_counter == 2'b11) begin
                        g <= 1;
                        state <= E;
                    end else if (y_counter > 2'b11) begin
                        g <= 0;
                        state <= F;
                    end
                end
                E: begin
                    
                end
                F: begin
                    
                end
                default: begin
                    
                    state <= A;
                    x_counter <= 2'b00;
                    y_counter <= 2'b00;
                    f <= 0;
                    g <= 0;
                end
            endcase
        end
    end
endmodule
