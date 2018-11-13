from flask import Flask, render_template, jsonify
import pandas as pd
app = Flask(__name__)

columns_df = pd.read_csv('metadata_columns.csv')
metadata_df = pd.read_csv('Belly_Button_Biodiversity_Metadata.csv')
otu_df = pd.read_csv('belly_button_biodiversity_otu_id.csv')
samples_df = pd.read_csv('belly_button_biodiversity_samples.csv')

names_df = samples_df.set_index('otu_id')

otu_df.set_index('otu_id', inplace=True)

sample_metadata_df = metadata_df[['AGE', 'BBTYPE', 'ETHNICITY', 'GENDER', 'LOCATION', 'SAMPLEID']]
sample_metadata_df.set_index('SAMPLEID', drop=False, inplace=True)
sample_metadata_dict = sample_metadata_df.to_dict('records')

wfreq_df = metadata_df[['SAMPLEID', 'WFREQ']]
wfreq_df.set_index('SAMPLEID', inplace=True)

title = "this is a title"

@app.route("/")
def index():
    return title #render_template('index.html')
    

@app.route('/names')
def list_of_names():
    names = list(names_df.columns.values)
    return jsonify(names)

@app.route('/otu')
def otu_descriptions():
    otu_list = otu_df['lowest_taxonomic_unit_found'].tolist()
    return jsonify(otu_list)

@app.route('/metadata/<sample>')
def metadata_for_sample(sample):
    sample = 'BB_940'
    sample = int(sample[3:])
    smdf = pd.DataFrame(sample_metadata_df.loc[sample])
    age = int(smdf.iloc[0][sample])
    bbtype = smdf.iloc[1][sample]
    ethnicity = smdf.iloc[2][sample]
    gender = smdf.iloc[3][sample]
    location = smdf.iloc[4][sample]
    sampleid = int(smdf.iloc[5][sample])
    metadata_dict = {'AGE': age, 'BBTYPE': bbtype, 'ETHNICITY': ethnicity, 'GENDER': gender, 
    'LOCATION': location, 'SAMPLEID': sampleid}
    return jsonify(metadata_dict)

@app.route('/wfreq/<sample>')
def wfreq_for_sample(sample):
    sample = int(sample[3:])
    sample_wfreq = float(wfreq_df.loc[sample])
    return jsonify(sample_wfreq)

@app.route('/samples/<sample>')
def info_for_sample(sample):
    info = samples_df.sort_values(sample, ascending=False)
    info_otu = info['otu_id'].tolist()
    info_values = info[sample].tolist()
    info_dict = {'otu_ids': info_otu, 'sample_values': info_values}
    return jsonify(info_dict)

if __name__ == "__main__":
    app.run(debug=True)