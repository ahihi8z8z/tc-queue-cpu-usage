from mininet.topo import Topo

num_sw = 3
bw = 1
class MyTopo( Topo ):
  "Simple topology example."

  def build( self ):
    "Create custom topo."
    # Add hosts and switches
    switches = [] 
    for i in range(1,num_sw+1):
        name = 's' + str(i)
        switches.append(self.addSwitch(name))

    # Add links
    for i in range(num_sw):
        for j in range(i+1,num_sw):
            if switches[i] != switches[j]:
                self.addLink(switches[i],switches[j],bw=bw,use_hfsc=True)

topos = { 'mytopo': ( lambda: MyTopo() ) }
