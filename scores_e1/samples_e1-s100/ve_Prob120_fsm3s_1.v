
module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    
    reg [1:0] state;
    wire output;

    
    always @(posedge clk) begin
        case (state)
            2'b00: begin
                if (in == 1) begin
                    state <= 2'b01;
                    output <= 0;
                end else begin
                    state <= 2'b00;
                    output <= 0;
                end
            end
            2'b01: begin
                if (in == 1) begin
                    state <= 2'b10;
                    output <= 0;
                end else begin
                    state <= 2'b01;
                    output <= 0;
                end
            end
            2'b10: begin
                if (in == 1) begin
                    state <= 2'b00;
                    output <= 0;
                end else begin
                    state <= 2'b11;
                    output <= 1;
                end
            end
            2'b11: begin
                if (in == 1) begin
                    state <= 2'b00;
                    output <= 0;
                end else begin
                    state <= 2'b10;
                    output <= 1;
                end
            end
        endcase
    end

    
    always @(posedge reset) begin
        state <= 2'b00;
        output <= 0;
    end

    
    assign out = output;

endmodule
