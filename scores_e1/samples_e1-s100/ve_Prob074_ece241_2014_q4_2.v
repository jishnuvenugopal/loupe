
module TopModule (
    input clk,
    input x,
    output z
);

    
    reg [1:0] d0, d1, d2;

    
    reg [1:0] state;

    
    reg [1:0] xnor_output;

    
    initial begin
        d0 = 2'b00;
        d1 = 2'b00;
        d2 = 2'b00;
        state = 2'b00;
        z = 1'b0;
    end

    
    always @(posedge clk) begin
        
        case (state)
            2'b00: begin
                if (x == 1'b1) begin
                    state = 2'b01;
                end else begin
                    state = 2'b00;
                end
            end
            2'b01: begin
                if (x == 1'b1) begin
                    state = 2'b10;
                end else begin
                    state = 2'b01;
                end
            end
            2'b10: begin
                if (x == 1'b1) begin
                    state = 2'b11;
                end else begin
                    state = 2'b10;
                end
            end
            2'b11: begin
                if (x == 1'b1) begin
                    state = 2'b00;
                end else begin
                    state = 2'b11;
                end
            end
        endcase

        
        xnor_output = {d0, d1, d2};

        
        d0 <= state[0];
        d1 <= state[1];
        d2 <= xnor_output;

        
        z <= xnor_output[0];

    end

endmodule
