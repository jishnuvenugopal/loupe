
module signal_generator (
    input wire clk,
    input wire rst_n,
    output reg [4:0] wave
);

    reg [4:0] state;
    reg [4:0] waveform;

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            state <= 5'b0;
            waveform <= 5'b0;
        end else begin
            case (state)
                5'b0: begin
                    waveform <= waveform + 1'b1;
                    if (waveform == 5'b31) begin
                        state <= 5'b1;
                        waveform <= 5'b31;
                    end
                end
                5'b1: begin
                    waveform <= waveform - 1'b1;
                    if (waveform == 5'b0) begin
                        state <= 5'b0;
                        waveform <= 5'b0;
                    end
                end
            endcase
        end
    end

endmodule
