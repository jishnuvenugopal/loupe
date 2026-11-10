
module TopModule (
    input wire x,
    input wire [2:0] y,
    output reg Y0,
    output reg z
);

    
    reg [2:0] current_state;
    reg [2:0] next_state;

    
    initial begin
        current_state = 3'b000;
        next_state = 3'b000;
        Y0 = 1'b0;
        z = 1'b0;
    end

    
    always @(posedge x or posedge y) begin
        case (current_state)
            3'b000: begin
                if (y == 3'b000) begin
                    next_state = 3'b000;
                    Y0 = 1'b0;
                    z = 1'b0;
                end else if (y == 3'b001) begin
                    next_state = 3'b001;
                    Y0 = 1'b0;
                    z = 1'b0;
                end else if (y == 3'b010) begin
                    next_state = 3'b010;
                    Y0 = 1'b0;
                    z = 1'b0;
                end else if (y == 3'b011) begin
                    next_state = 3'b001;
                    Y0 = 1'b0;
                    z = 1'b0;
                end else if (y == 3'b100) begin
                    next_state = 3'b011;
                    Y0 = 1'b1;
                    z = 1'b1;
                end
            end
            3'b001: begin
                if (y == 3'b000) begin
                    next_state = 3'b001;
                    Y0 = 1'b0;
                    z = 1'b0;
                end else if (y == 3'b001) begin
                    next_state = 3'b001;
                    Y0 = 1'b0;
                    z = 1'b0;
                end else if (y == 3'b010) begin
                    next_state = 3'b010;
                    Y0 = 1'b0;
                    z = 1'b0;
                end else if (y == 3'b011) begin
                    next_state = 3'b001;
                    Y0 = 1'b0;
                    z = 1'b0;
                end else if (y == 3'b100) begin
                    next_state = 3'b011;
                    Y0 = 1'b1;
                    z = 1'b1;
                end
            end
            3'b010: begin
                if (y == 3'b000) begin
                    next_state = 3'b010;
                    Y0 = 1'b0;
                    z = 1'b0;
                end else if (y == 3'b001) begin
                    next_state = 3'b001;
                    Y0 = 1'b0;
                    z = 1'b0;
                end else if (y == 3'b010) begin
                    next_state = 3'b010;
                    Y0 = 1'b0;
                    z = 1'b0;
                end else if (y == 3'b011) begin
                    next_state = 3'b001;
                    Y0 = 1'b0;
                    z = 1'b0;
                end else if (y == 3'b100) begin
                    next_state = 3'b011;
                    Y0 = 1'b1;
                    z = 1'b1;
                end
            end
            3'b011: begin
                if (y == 3'b000) begin
                    next_state = 3'b001;
                    Y0 = 1'b0;
                    z = 1'b0;
                end else if (y == 3'b001) begin
                    next_state = 3'b001;
                    Y0 = 1'b0;
                    z = 1'b0;
                end else if (y == 3'b010) begin
                    next_state = 3'b010;
                    Y0 = 1'b0;
                    z = 1'b0;
                end else if (y == 3'b011) begin
                    next_state = 3'b001;
                    Y0 = 1'b0;
                    z = 1'b0;
                end else if (y == 3'b100) begin
                    next_state = 3'b011;
                    Y0 = 1'b1;
                    z = 1'b1;
                end
            end
            3'b100: begin
                if (y == 3'b000) begin
                    next_state = 3'b001;
                    Y0 = 1'b0;
                    z = 1'b0;
                end else if (y == 3'b001) begin
                    next_state = 3'b001;
                    Y0 = 1'b0;
                    z = 1'b0;
                end else if (y == 3'b010) begin
                    next_state = 3'b010;
                    Y0 = 1'b0;
                    z = 1'b0;
                end else if (y == 3'b011) begin
                    next_state = 3'b001;
                    Y0 = 1'b0;
                    z = 1'b0;
                end else if (y == 3'b100) begin
                    next_state = 3'b011;
                    Y0 = 1'b1;
                    z = 1'b1;
                end
            end
        endcase
    end

    
    always @(*) begin
        if (current_state == 3'b000) begin
            Y0 = 1'b0;
            z = 1'b0;
        end else if (current_state == 3'b001) begin
            Y0 = 1'b0;
            z = 1'b0;
        end else if (current_state == 3'b010) begin
            Y0 = 1'b0;
            z = 1'b0;
        end else if (current_state == 3'b011) begin
            Y0 = 1'b0;
            z = 1'b0;
        end else if (current_state == 3'b100) begin
            Y0 = 1'b1;
            z = 1'b1;
        end
    end

endmodule
