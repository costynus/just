# Pretty-printer for goose review JSONL findings: colored list sorted by severity + summary table.
# Used by the greview / greview-lite targets in the Justfile. Standalone: goose review | jq -Rrs -f greview.jq
[split("\n")[] | fromjson?] as $items
|
(
$items
| sort_by(
if .severity == "critical" then 0
elif .severity == "high" then 1
elif .severity == "medium" then 2
elif .severity == "low" then 3
else 4
end
)
| .[]
| (
if .severity == "critical" then "\u001b[31;1mCRITICAL\u001b[0m"
elif .severity == "high" then "\u001b[31mHIGH\u001b[0m"
elif .severity == "medium" then "\u001b[33;1mMEDIUM\u001b[0m"
elif .severity == "low" then "\u001b[36mLOW\u001b[0m"
else (.severity | ascii_upcase)
end
)
+ "  \u001b[1m\(.path):\(.line_start)"
+ (
if .line_end != null and .line_end != .line_start
then "-\(.line_end)"
else ""
end
)
+ "\u001b[0m"
+ (
if .check != null
then "  \u001b[2m[\(.check)]\u001b[0m"
else ""
end
)
+ "\n  \(.summary)\n"
),
(
"\n\u001b[1mSummary\u001b[0m",
"────────────────────────────────────────────────",
"FILE                     \u001b[31;1mCRIT\u001b[0m  \u001b[31mHIGH\u001b[0m  \u001b[33;1mMED\u001b[0m  \u001b[36mLOW\u001b[0m",
"────────────────────────────────────────────────",
(
$items
| group_by(.path)[]
| . as $file
| ($file[0].path | .[0:23]) as $path
| $path
+ (" " * (25 - ($path | length)))
+ "\u001b[31;1m\([$file[] | select(.severity == "critical")] | length)\u001b[0m"
+ (" " * 5)
+ "\u001b[31m\([$file[] | select(.severity == "high")] | length)\u001b[0m"
+ (" " * 5)
+ "\u001b[33;1m\([$file[] | select(.severity == "medium")] | length)\u001b[0m"
+ (" " * 4)
+ "\u001b[36m\([$file[] | select(.severity == "low")] | length)\u001b[0m"
),
"────────────────────────────────────────────────",
(
"TOTAL"
+ (" " * 20)
+ "\u001b[31;1m\([$items[] | select(.severity == "critical")] | length)\u001b[0m"
+ (" " * 5)
+ "\u001b[31m\([$items[] | select(.severity == "high")] | length)\u001b[0m"
+ (" " * 5)
+ "\u001b[33;1m\([$items[] | select(.severity == "medium")] | length)\u001b[0m"
+ (" " * 4)
+ "\u001b[36m\([$items[] | select(.severity == "low")] | length)\u001b[0m"
)
)
