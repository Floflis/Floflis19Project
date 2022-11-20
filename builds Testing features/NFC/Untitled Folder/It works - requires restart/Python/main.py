#! /usr/bin/env python

from __future__ import print_function
from time import sleep

from smartcard.CardConnectionObserver import ConsoleCardConnectionObserver
from smartcard.CardMonitoring import CardMonitor, CardObserver
from smartcard.util import toHexString
from evdev import UInput, ecodes
import uinput


device = uinput.Device([uinput.KEY_0, uinput.KEY_1, uinput.KEY_2, uinput.KEY_3, uinput.KEY_4, uinput.KEY_5, uinput.KEY_6, uinput.KEY_7, uinput.KEY_8, uinput.KEY_9, uinput.KEY_A, uinput.KEY_B, uinput.KEY_C, uinput.KEY_D, uinput.KEY_E, uinput.KEY_F, uinput.KEY_G, uinput.KEY_H, uinput.KEY_I, uinput.KEY_J, uinput.KEY_K, uinput.KEY_L, uinput.KEY_M, uinput.KEY_N, uinput.KEY_O, uinput.KEY_P, uinput.KEY_Q, uinput.KEY_R, uinput.KEY_S, uinput.KEY_T, uinput.KEY_U, uinput.KEY_V, uinput.KEY_W, uinput.KEY_X, uinput.KEY_Y, uinput.KEY_Z, uinput.KEY_TAB])


def card_id_to_keyboards(card_id):
    id = card_id.replace(' ', '')

    return [getattr(uinput, 'KEY_'+x.upper()) for x in id]


# a simple card observer that tries to select DF_TELECOM on an inserted card
class selectDFTELECOMObserver(CardObserver):
    """A simple card observer that is notified
    when cards are inserted/removed from the system and
    prints the list of cards
    """

    def __init__(self):
        self.observer = ConsoleCardConnectionObserver()

    def update(self, observable, actions):
        try:
            (addedcards, removedcards) = actions
            for card in addedcards:
                print("+Inserted: ", toHexString(card.atr))
                card.connection = card.createConnection()
                card.connection.connect()
                card.connection.addObserver(self.observer)
                apdu = [0xFF, 0xCA, 0x00, 0x00, 0x00]
                response, sw1, sw2 = card.connection.transmit(apdu)
                keys = card_id_to_keyboards(toHexString(response))
                for key in keys:
                    device.emit_click(key)
                ui = UInput()
                ui.write(ecodes.EV_KEY, ecodes.KEY_ENTER, 0)
                ui.write(ecodes.EV_KEY, ecodes.KEY_ENTER, 1)
                ui.syn()
                ui.close()
            for card in removedcards:
                print("-Removed: ", toHexString(card.atr))
        except:
            pass

if __name__ == '__main__':
    print("Insert or remove a SIM card in the system.")
    print("This program will exit in 60 seconds")
    print("")
    cardmonitor = CardMonitor()
    selectobserver = selectDFTELECOMObserver()
    cardmonitor.addObserver(selectobserver)

    sleep(86400)

    # don't forget to remove observer, or the
    # monitor will poll forever...
    cardmonitor.deleteObserver(selectobserver)

    import sys
    if 'win32' == sys.platform:
        print('press Enter to continue')
        sys.stdin.read(1)
