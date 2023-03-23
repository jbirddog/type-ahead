import json
import requests

def sim(query, limit):
    prefix = ""
    results = []
    for c in query:
        prefix += c
        print(f"Finding cities that start with: {prefix}...")
        response = requests.get(f"http://localhost:5000/cities?prefix={prefix}&limit={limit}")
        results.append((prefix, response.text))
    print("Processing results...")
    report = []
    for prefix, raw_response in results:
        response = json.loads(raw_response)
        lines = []
        for item in response:
            names = item["cityStateAndCountryName"]
            lines.append(f"\t{names[0]} ({names[1]}, {names[2]})")
        report.append(f"{prefix}: {len(response)}")
        report.append("\n".join(lines))
        report.append("")
    print("\nResult:\n")
    print("\n".join(report))
    #print(json.dumps(results, indent=4))

if __name__ == "__main__":
    query = input()
    limit = 100
    sim(query, limit)
