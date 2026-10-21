
module TopModule (
    input clk,
    input resetn,
    input [2:0] r,
    output reg [2:0] g
);

    
    parameter A = 3'b000,
             B = 3'b001,
             C = 3'b010;

    
    reg [2:0] current_state;
    reg [2:0] next_state;

    
    reg [2:0] priority;

    
    always @(posedge clk or posedge resetn) begin
        if (resetn) begin
            current_state <= A;
            priority <= 3'b000;
        end else begin
            case (current_state)
                A: begin
                    if (r[0] == 1) begin
                        next_state <= B;
                        priority <= 3'b001;
                    end else if (r[1] == 1) begin
                        next_state <= C;
                        priority <= 3'b010;
                    end else begin
                        next_state <= A;
                    end
                end
                B: begin
                    if (r[0] == 1) begin
                        next_state <= B;
                        priority <= 3'b001;
                    end else if (r[1] == 1) begin
                        next_state <= A;
                        priority <= 3'b010;
                    end else begin
                        next_state <= B;
                    end
                end
                C: begin
                    if (r[0] == 1) begin
                        next_state <= C;
                        priority <= 3'b010;
                    end else if (r[1] == 1) begin
                        next_state <= A;
                        priority <= 3'b010;
                    end else begin
                        next_state <= C;
                    end
                end
            endcase
        end
    end

    
    always @(posedge clk or posedge resetn) begin
        if (resetn) begin
            current_state <= A;
            priority <= 3'b000;
        end else begin
            current_state <= next_state;
            priority <= next_priority;
        end
    end

    
    always @(posedge clk or posedge resetn) begin
        if (resetn) begin
            g <= 3'b000;
        end else begin
            case (priority)
                3'b000: g <= 3'b000;
                3'b001: g <= 3'b001;
                3'b010: g <= 3'b010;
            endcase
        end
    end

endmodule
