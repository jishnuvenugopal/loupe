
module TopModule (
    input    y [],
    input    w,
    output   Y1,
    output   Y3
);
    
    localparam A = 6'b000001;
    localparam B = 6'b000010;
    localparam C = 6'b000100;
    localparam D = 6'b001000;
    localparam E = 6'b010000;
    localparam F = 6'b100000;

    
    reg [5:0] CurrentState;

    
    reg [5:0] NextState;

    always @(CurrentState or y or w) begin
        case (CurrentState)
            A:
                if (y[1] == 1'b0) NextState = B;
                else NextState = A;

            B:
                if (y[1] == 1'b0) NextState = C;
                else NextState = D;

            C:
                if (y[1] == 1'b0) NextState = E;
                else NextState = D;

            D:
                if (y[1] == 1'b0) NextState = F;
                else NextState = A;

            E:
                NextState = (y[3] == 1'b0) ? E : D;

            F:
                if (y[3] == 1'b0) NextState = C;
                else NextState = D;

            default:
                NextState = A;
 
        endcase
    end

    
    always @(posedge w or negedge y[0]) begin
        if (!y[0]) CurrentState <= A;
 
        else CurrentState <= NextState;
    end

    
    assign Y1 = CurrentState[5];
    assign Y3 = ~(CurrentState[5] | CurrentState[3] | CurrentState[1]);

endmodule
