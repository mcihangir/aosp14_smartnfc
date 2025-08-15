package smartnfc.hardware.led;

//@VintfStability
interface ISmartLed {
    void setLedState(String ledName, int state); // 0=off, 1=on
    int getLedState(String ledName);             // returns current state
}
