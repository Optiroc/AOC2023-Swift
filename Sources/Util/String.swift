extension String {
    func firstAndLastOccurence(of substrings: some Collection<String>) -> (String, String)? {
        var f: (String?, String.Index) = (nil, self.endIndex)
        var l: (String?, String.Index) = (nil , self.startIndex)
        for s in substrings {
            for r in self.ranges(of: s) {
                if r.lowerBound < f.1 { f = (s, r.lowerBound) }
                if r.lowerBound >= l.1 { l = (s, r.lowerBound) }
            }
        }
        if let first = f.0, let last = l.0 {
            return (first, last)
        }
        return nil
    }
}
