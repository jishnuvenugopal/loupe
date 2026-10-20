
module TopModule (
    input  x,
    input  [2:0] y,
    output reg Y0,
    output reg z
);


typedef enum { S0, S1, S2, S3 } state_t;


state_t current_state, next_state;


always @(*) begin
    current_state = S0;
 
end


always @(posedge x or posedge y) begin
    case (current_state)
        S0: begin
            if (y == 3'b000) next_state = S0;
            else if (y == 3'b001) next_state = S1;
            else if (y == 3'b010) next_state = S2;
            else if (y == 3'b011) next_state = S3;
        end
        S1: begin
            if (y == 3'b000) next_state = S1;
            else if (y == 3'b001) next_state = S2;
            else if (y == 3'b010) next_state = S3;
            else if (y == 3'b011) next_state = S0;
        end
        S2: begin
            if (y == 3'b000) next_state = S2;
            else if (y == 3'b001) next_state = S3;
            else if (y == 3'b010) next_state = S0;
            else if (y == 3'b011) next_state = S1;
        end
        S3: begin
            if (y == 3'b000) next_state = S3;
            else if (y == 3'b001) next_state = S0;
            else if (y == 3'b010) next_state = S1;
            else if (y == 3'b011) next_state = S2;
        end
    endcase
end


always @(posedge x or posedge y) begin
    case (current_state)
        S0: begin
            Y0 = next_state[0];
            z = 1'b0;
        end
        S1: begin
            Y0 = next_state[0];
            z = 1'b0;
        end
        S2: begin
            Y0 = next_state[0];
            z = 1'b0;
        end
        S3: begin
            Y0 = next_state[0];
            z = 1'b1;
        end
    endcase
end

endmodule
