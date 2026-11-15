# MIT 8103 — official LMS submission naming and privacy

This guide reflects the **MIT 8103 Submission — CA September Cohort 2026** LMS naming screenshot supplied for the assignment.

## Exact naming rules

- **Folder:** `Surname_Firstname_StudentID/`
- **Every uploaded file inside that folder:** `Surname_Firstname_StudentID_DocumentType.ext`
- **No spaces** and no generic names like `Assignment.pdf`, `Final File.docx` or `Document.pdf`
- The **student ID appears in the folder name and every filename**.
- The **matric/registration number** is a separate field. Put it in the summary's content where requested, **not** in the filename. A matric number containing `/` is not a suitable filesystem name.

### Illustrative fictional example (NOT actual student details)

```text
Example_Member_123456789/
  Example_Member_123456789_PortfolioSummary.pdf
  Example_Member_123456789_PortfolioSummary.docx
  Example_Member_123456789_README.txt
  Example_Member_123456789_ERDiagram.png
  Example_Member_123456789_Evidence.zip
```

## Apply privately before uploading to the LMS

1. Start from the final, **verified** Word/PDF summary. Do not upload unfinished templates as finished work.
2. Make the personally identified folder **outside the public GitHub repository**, or under a local gitignored `private_submission/` directory.
3. Rename the folder and files to match the official rule, then insert your real name, student ID and matric number **into the document as appropriate**.
4. Check file contents, AI declaration, supporting evidence and the assessor's repository access.
5. Double-check final LMS upload names and the one-attempt submission instructions.

**Public-repository safety:** A public GitHub repository is accessible to anyone. Do not commit your student ID, matric number, or other personally identifying academic records. If the assessor requires the repository itself to be private, use GitHub private collaborator access rather than making personal information public.

## Related files

- [LMS portfolio summary template](01_LMS_summary_template.md)
- [Final checklist](04_final_checklist.md)
- [AI-use declaration](02_ai_use_declaration_template.md)
