
module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  disc,
    output reg  flag,
    output reg  err
);

    
    reg [2:0] counter;

    
    always @(posedge clk) begin
        if (reset) begin
            counter <= 3'b000;
            disc   <= 1'b0;
            flag   <= 1'b0;
            err    <= 1'b0;
        end else begin
            
            if (in) begin
                if (counter == 3'b111) begin
                    counter <= 3'b000;
                    disc   <= 1'b1;
                end else begin
                    counter <= counter + 1'b1;
                    disc   <= 1'b0;
                    flag   <= 1'b0;
                    err    <= 1'b0;
                end
            end else begin
                counter <= 3'b000;
                disc   <= 1'b0;
                flag   <= 1'b0;
                err    <= 1'b0;
            end
            
            if (counter == 3'b111111) begin
                counter <= 3'b000;
                flag   <= 1'b1;
            end
            
            if (counter == 3'b1111111) begin
                counter <= 3'b000;
                err    <= 1'b1;
            end
            
            if (counter == 3'b11111) begin
                counter <= 3'b000;
                disc   <= 1'b1;
            end
        end
    end

endmodule
