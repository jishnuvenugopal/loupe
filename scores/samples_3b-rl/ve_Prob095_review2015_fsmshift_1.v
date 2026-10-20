
module TopModule (
    input  wire clk,
    input  wire reset,
    output reg  shift_ena
);

    
    reg [1:0] counter;
    
    reg state;

    
    wire [1:0] pattern = 2'b11;

    always @(posedge clk) begin
        if (reset) begin
            counter <= 2'b00;
            state   <= 1'b0;
            shift_ena <= 1'b0;
        end else begin
            if (state == 1'b0) begin
                
                if (counter == 2'b11) begin
                    counter <= 2'b00;
                    state   <= 1'b1;
                    shift_ena <= 1'b0;
                end else begin
                    counter <= counter + 2'b01;
                    shift_ena <= 1'b0;
                end
            end else begin
                
                if (counter == 2'b00) begin
                    if (shift_ena == 1'b0) begin
                        shift_ena <= 1'b1;
                    end
                    counter <= counter + 2'b01;
                end else if (counter == 2'b01) begin
                    counter <= counter + 2'b01;
                end else if (counter == 2'b10) begin
                    counter <= counter + 2'b01;
                end else if (counter == 2'b11) begin
                    counter <= counter + 2'b01;
                    shift_ena <= 1'b0;
                    state <= 1'b0;
                end else begin
                    counter <= counter + 2'b01;
                    shift_ena <= 1'b0;
                end
            end
        end
    end

endmodule
