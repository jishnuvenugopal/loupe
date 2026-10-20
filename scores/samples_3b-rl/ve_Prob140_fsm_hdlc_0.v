
module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  disc,
    output reg  flag,
    output reg  err
);

    
    reg [6:0] count;
    
    reg [2:0] state;

    
    
    
    
    
    
    
    
    

    always @(posedge clk) begin
        if (reset) begin
            count  <= 7'd0;
            state  <= 3'd0;
            disc   <= 1'b0;
            flag   <= 1'b0;
            err    <= 1'b0;
        end else begin
            case (state)
                3'd0: begin 
                    if (in) begin
                        count <= 7'd1;
                        state <= 3'd1;
                    end else begin
                        count <= 7'd0;
                        state <= 3'd0;
                    end
                end
                3'd1: begin 
                    if (in) begin
                        count <= count + 1'b1;
                        state <= 3'd1;
                    end else begin
                        count <= 7'd0;
                        state <= 3'd0;
                    end
                end
                3'd2: begin 
                    if (in) begin
                        count <= count + 1'b1;
                        state <= 3'd2;
                    end else begin
                        count <= 7'd0;
                        state <= 3'd0;
                    end
                end
                3'd3: begin 
                    if (in) begin
                        count <= count + 1'b1;
                        state <= 3'd3;
                    end else begin
                        count <= 7'd0;
                        state <= 3'd0;
                    end
                end
                3'd4: begin 
                    count <= 7'd0;
                    state <= 3'd0;
                    disc   <= 1'b1;
                end
                3'd5: begin 
                    count <= 7'd0;
                    state <= 3'd0;
                    flag   <= 1'b1;
                end
                3'd6: begin 
                    count <= 7'd0;
                    state <= 3'd0;
                    err    <= 1'b1;
                end
                3'd7: begin 
                    count <= 7'd0;
                    state <= 3'd0;
                    disc   <= 1'b0;
                    flag   <= 1'b0;
                    err    <= 1'b0;
                end
                default: begin
                    count <= 7'd0;
                    state <= 3'd0;
                    disc   <= 1'b0;
                    flag   <= 1'b0;
                    err    <= 1'b0;
                end
            endcase
        end
    end

endmodule
