
module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);


localparam A = 3'd0;
localparam B = 3'd1;
localparam C = 3'd2;
localparam D = 3'd3;
localparam E = 3'd4;
localparam F = 3'd5;
localparam H = 3'd6;

reg [2:0] state, next_state;
reg [1:0] counter;

always @(posedge clk) begin
    if (!resetn) begin
        state <= A;
        counter <= 2'b0;
    end else begin
        state <= next_state;
        
        if (next_state == F && state != F) begin
            counter <= 2'b10;
 
        end else if (state == F) begin
            if (y) begin
                counter <= 2'b10;
 
            end else begin
                counter <= counter - 1;
            end
        end else begin
            counter <= 2'b0;
        end
    end
end

always @(*) begin
    case (state)
        A: begin
            f = 0;
            g = 0;
            next_state = resetn ? B : A;
        end
        B: begin
            f = 1;
            g = 0;
            next_state = C;
        end
        C: begin
            f = 0;
            g = 0;
            if (x) begin
                next_state = D;
            end else begin
                next_state = A;
            end
        end
        D: begin
            f = 0;
            g = 0;
            if (x == 0) begin
                next_state = E;
            end else begin
                next_state = C;
            end
        end
        E: begin
            f = 0;
            g = 0;
            if (x == 1) begin
                next_state = F;
            end else begin
                next_state = C;
            end
        end
        F: begin
            f = 0;
            g = 1;
            if (counter == 2'b00) begin
                if (y) begin
                    next_state = F;
                end else begin
                    next_state = H;
                end
            end else begin
                next_state = F;
            end
        end
        H: begin
            f = 0;
            g = 0;
            next_state = H;
        end
        default: begin
            f = 0;
            g = 0;
            next_state = A;
        end
    endcase
end

endmodule
