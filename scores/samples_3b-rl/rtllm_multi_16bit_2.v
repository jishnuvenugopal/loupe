
module multi_16bit (
    input        clk,
    input        rst_n,
    input        start,
    input [15:0] ain,
    input [15:0] bin,
    output reg [31:0] yout,
    output reg       done
);

    reg [15:0] areg;
    reg [15:0] breg;
    reg [31:0] yout_r;
    reg       done_r;
    reg       [3:0] i;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            i        <= 4'd0;
            areg     <= 16'd0;
            breg     <= 16'd0;
            yout_r   <= 32'd0;
            done_r   <= 1'b0;
        end else begin
            if (start) begin
                if (i == 4'd16) begin
                    done_r <= 1'b1;
                end else if (i == 4'd17) begin
                    done_r <= 1'b0;
                end else begin
                    if (ain[i-1])
                        yout_r <= yout_r + (breg << i);
                    i <= i + 4'd1;
                end
            end else begin
                i        <= 4'd0;
                areg     <= 16'd0;
                breg     <= 16'd0;
                yout_r   <= 32'd0;
                done_r   <= 1'b0;
            end
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            done_r <= 1'b0;
        end else begin
            done_r <= done;
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            yout_r <= 32'd0;
        end else begin
            yout_r <= yout;
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            i <= 4'd0;
        end else begin
            i <= i;
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            areg <= 16'd0;
        end else begin
            areg <= ain;
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            breg <= 16'd0;
        end else begin
            breg <= bin;
        end
    end

    assign yout = yout_r;
    assign done = done_r;

endmodule
