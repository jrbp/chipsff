from .config import CHIPSFFConfig
# FIXME:  The following triggers download of data from jarvis
# which is sort of alarming on merely running 'import chipsff'
# put MaterialsAnalyzer in a separate file, put the data downloads in __main__, or (better) both
from .run_chipsff import MaterialsAnalyzer
