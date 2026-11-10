
module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

    
    reg [1:0] state = 2'b00;

    
    reg [7:0] counter = 8'b00000000;

    
    reg [7:0] current_state = 8'b00000000;

    
    reg [7:0] output = 8'b00000000;

    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 2'b00;
            counter <= 8'b00000000;
            current_state <= 8'b00000000;
            output <= 8'b00000000;
        end else begin
            if (state == 2'b00) begin
                if (counter == 8'b00000000) begin
                    state <= 2'b01;
                    counter <= 8'b00000000;
                    current_state <= 8'b00000000;
                    output <= 8'b00000000;
                end else begin
                    state <= 2'b00;
                    counter <= counter + 1'b1;
                    current_state <= current_state + 1'b1;
                    output <= output + 1'b1;
                end
            end else begin
                if (counter == 8'b00000000) begin
                    state <= 2'b00;
                    counter <= 8'b00000000;
                    current_state <= 8'b00000000;
                    output <= 8'b00000000;
                end else begin
                    state <= 2'b01;
                    counter <= counter + 1'b1;
                    current_state <= current_state + 1'b1;
                    output <= output ^ 1'b1;
                end
            end
        end
    end

    
    always @(*) begin
        if (state == 2'b00) begin
            output <= 8'b00000000;
        end else begin
            output <= current_state;
        end
    end

endmodule
