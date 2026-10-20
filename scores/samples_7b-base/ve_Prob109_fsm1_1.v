
module TopModule(
    input clk,
    input areset,
    input in,
    output out
);


 parameter STATE_A = 1'b0;
 parameter STATE_B = 1'b1;


reg current_state, next_state;


wire output_value;


always @(posedge clk or posedge areset) begin
    if (areset) begin
        current_state <= STATE_B;
    end else begin
        current_state <= next_state;
    end
end


assign output_value = current_state;


always @(*) begin
    case (current_state)
        STATE_A:
            if (in == 1'b0)
                next_state = STATE_B;
            else
                next_state = STATE_A;
        STATE_B:
            if (in == 1'b0)
                next_state = STATE_A;
            else
                next_state = STATE_B;
        default: 
            next_state = STATE_B;
    endcase
end


assign out = output_value;

endmodule
