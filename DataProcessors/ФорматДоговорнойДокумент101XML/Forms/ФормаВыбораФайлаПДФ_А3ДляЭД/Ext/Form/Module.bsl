﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	РежимВыбораФайла = "ПечатнаяФормаДокумента";
	Если Параметры.Свойство("ПараметрыФормыЭД") Тогда  
		
		Если ТипЗнч(Параметры.ПараметрыФормыЭД) = Тип("Структура") Тогда   
			ОбъектУчета = Параметры.ПараметрыФормыЭД.ОбъектУчета; 
		Иначе	
			ОбъектУчета = Параметры.ПараметрыФормыЭД;
		КонецЕсли; 
		
		ПараметрыФормыЭД = Параметры.ПараметрыФормыЭД;
		ЗаполнитьСписокШаблоновДоговоров(ОбъектУчета); 
		
	КонецЕсли
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПродолжитьКоманда(Команда) 
		
	Если РежимВыбораФайла = "СДиска" Тогда
		Закрыть();  
		
		// ЭлектронноеВзаимодействие.ОбменСКонтрагентами
		ОбработчикЗавершения = Новый ОписаниеОповещения("ПоказатьСправкуПоФорматуДоговорногоДокумента", ИнтерфейсДокументовЭДОУТКлиент,
				ПараметрыФормыЭД);
				
		ПараметрыЗагрузки = Новый Структура("МаксимальныйРазмер, ФильтрДиалогаВыбора, НеОткрыватьКарточку");
		ПараметрыЗагрузки.ФильтрДиалогаВыбора = НСтр("ru = 'Файл PDF'") + " (*.pdf)|*.pdf";
		ПараметрыЗагрузки.МаксимальныйРазмер = 0;
		ПараметрыЗагрузки.НеОткрыватьКарточку = Истина;
		
		РаботаСФайламиКлиент.ДобавитьФайл(ОбработчикЗавершения, ОбъектУчета, ЭтотОбъект, 2, ПараметрыЗагрузки);
		
	ИначеЕсли РежимВыбораФайла = "ПрисоединенныйФайл" Тогда
		Закрыть();
		ИнтерфейсДокументовЭДОУТКлиент.ОткрытьФормуВыбораПрисоединенногоФайлаДоговорногоДокумента(ПараметрыФормыЭД);
		// Конец ЭлектронноеВзаимодействие.ОбменСКонтрагентами					
	ИначеЕсли РежимВыбораФайла = "ПечатнаяФормаДокумента" Тогда 
		Если ЗначениеЗаполнено(ТекущийШаблонДоговора) Тогда 
			ДлительнаяОперация = НачатьФормированиеПечатныхФорм(ТекущийШаблонДоговора);
			Контекст = Новый Структура("ИменаМакетов", ТекущийШаблонДоговора);
			ОповещениеОЗавершении = Новый ОписаниеОповещения("ПриЗавершенииФормированияПечатныхФорм", ЭтотОбъект, Контекст);
			ДлительныеОперацииКлиент.ОжидатьЗавершение(ДлительнаяОперация, ОповещениеОЗавершении, ПараметрыОжидания());
		Иначе
			ОчиститьСообщения();
			Сообщение = Новый СообщениеПользователю;
			Сообщение.Текст = "Не выбран шаблон договора.";
			Сообщение.Поле="ТекущийШаблонДоговора";
			Сообщение.ПутьКДанным = "ТекущийШаблонДоговора";
			Сообщение.Сообщить();
		КонецЕсли;	
	КонецЕсли;
	
КонецПроцедуры 

#КонецОбласти  

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьСписокШаблоновДоговоров(СсылкаНаДоговор) 
	
	Если Не ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.Печать") Тогда
		Возврат;
	КонецЕсли;
	МодульУправлениеПечатью = ОбщегоНазначения.ОбщийМодуль("УправлениеПечатью");
	
	СписокОбъектов = Новый Массив;
	СписокОбъектов.Добавить(СсылкаНаДоговор.Метаданные());
	
	КомандыПечати = МодульУправлениеПечатью.КомандыПечатиФормы("Справочник.ДоговорыКонтрагентов.Форма.ФормаЭлемента", СписокОбъектов);
	
	Для Каждого ПечатнаяФорма Из КомандыПечати Цикл  
		ШаблоныДоговоров.Добавить(ПечатнаяФорма.Идентификатор, ПечатнаяФорма.Представление);
		Элементы.ТекущийШаблонДоговора.СписокВыбора.Добавить(ПечатнаяФорма.Идентификатор, ПечатнаяФорма.Представление);
	КонецЦикла; 
		
КонецПроцедуры

&НаСервере
Функция НачатьФормированиеПечатныхФорм(ИменаМакетов)
	
	УникальныйИдентификаторХранилища = Новый УникальныйИдентификатор;
	
	ПараметрКоманды = Новый Массив();
	ПараметрКоманды.Добавить(ОбъектУчета); 
	
	ПараметрыПечати = Новый Структура();
	ПараметрыПечати.Вставить("Идентификатор", ИменаМакетов);
	ПараметрыПечати.Вставить("МенеджерПечати", "УправлениеПечатью");
	ПараметрыПечати.Вставить("ОбъектыПечати", ПараметрКоманды);
	ДополнительныеПараметрыСтруктура = Новый Структура("ПодписьИПечать",	
		ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("ПечатьДокументовOfficeOpen", "ПодписьИПечать", Ложь));
	ПараметрыПечати.Вставить("ДополнительныеПараметры", ДополнительныеПараметрыСтруктура);
	
	СтруктураПараметров = ПараметрыОткрытияФормыПечати();
	СтруктураПараметров.УникальныйИдентификаторХранилища = УникальныйИдентификаторХранилища; 
	СтруктураПараметров.ИсточникДанных = Неопределено;
	СтруктураПараметров.ИмяМенеджераПечати = "УправлениеПечатью";  
	СтруктураПараметров.ПараметрКоманды = ПараметрКоманды;	
	СтруктураПараметров.ПараметрыПечати = ПараметрыПечати; 
		
	СтруктураПараметров.Вставить("ИменаМакетов", ИменаМакетов);

	Возврат УправлениеПечатьюВызовСервера.НачатьФормированиеПечатныхФорм(СтруктураПараметров); 
	
КонецФункции

&НаКлиенте
Процедура ПриЗавершенииФормированияПечатныхФорм(Результат, Знач Контекст) Экспорт
	
	Если Результат <> Неопределено Тогда
		Если Результат.Статус = "Ошибка" Тогда
			ВызватьИсключение Результат.КраткоеПредставлениеОшибки;
		КонецЕсли;
		СтруктураРезультата = ПолучитьРезультатФоновогоЗадания(Результат);
		КоллекцияПечатныхФорм = СтруктураРезультата.КоллекцияПечатныхФорм; 
		
		ИмяШаблона = КоллекцияПечатныхФорм[0].СинонимМакета;
			
		Если КоллекцияПечатныхФорм[0].ОфисныеДокументы <> Неопределено Тогда
			СохранитьФайлПоШаблону(Истина, ИмяШаблона);
		Иначе
			СохранитьФайлПоШаблону(Ложь, ИмяШаблона);
		КонецЕсли;
		
	КонецЕсли; 			

КонецПроцедуры 

&НаКлиенте
Процедура СохранитьФайлПоШаблону(ОфисныйДокумент, ИмяШаблона)

	ДлительнаяОперация = НачатьСохранениеФайлаПоШаблону();
	Контекст = Новый Структура("ОфисныйДокумент, ИмяШаблона", ОфисныйДокумент, ИмяШаблона);
	ОповещениеОЗавершении = Новый ОписаниеОповещения("ПриЗавершенииСохраненияФайла", ЭтотОбъект, Контекст);
	ДлительныеОперацииКлиент.ОжидатьЗавершение(ДлительнаяОперация, ОповещениеОЗавершении, ПараметрыОжидания()); 

КонецПроцедуры

&НаСервере
Функция НачатьСохранениеФайлаПоШаблону()

	СписокОбъектовМетаданные = Новый Массив();
	СписокОбъектовМетаданные.Добавить(ОбъектУчета.Метаданные());	
	КомандыПечати = УправлениеПечатью.КомандыПечатиФормы("Справочник.ДоговорыКонтрагентов.Форма.ФормаЭлемента", СписокОбъектовМетаданные);
	КомандаПечати = КомандыПечати.НайтиСтроки(Новый Структура("Идентификатор", ТекущийШаблонДоговора));

	СписокОбъектов = Новый Массив();
	СписокОбъектов.Добавить(ОбъектУчета);
	
	Результат = ОбщегоНазначения.СтрокаТаблицыЗначенийВСтруктуру(КомандаПечати[0]);
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияФункции(УникальныйИдентификаторХранилища);
	ПараметрыВыполнения.ЗапуститьВФоне = Истина;
	Возврат ДлительныеОперации.ВыполнитьФункцию(ПараметрыВыполнения, "УправлениеПечатью.НапечататьВФайл",
		Результат, СписокОбъектов, УправлениеПечатью.НастройкиСохранения());
			
КонецФункции 

&НаКлиенте
Процедура ПриЗавершенииСохраненияФайла(Результат, Знач Контекст) Экспорт
	
	Если Результат <> Неопределено Тогда
		Если Результат.Статус = "Ошибка" Тогда
			ВызватьИсключение Результат.КраткоеПредставлениеОшибки;
		КонецЕсли;
		
		СтруктураРезультата = ПолучитьРезультатФоновогоЗадания(Результат);
		ДобавленныйФайл = СтруктураРезультата; 
		Закрыть();
		
		// ЭлектронноеВзаимодействие.ОбменСКонтрагентами
		Если Контекст.ОфисныйДокумент = Истина Тогда 
			ПараметрыФормы = Новый Структура();
			ПараметрыФормы.Вставить("ПараметрыФормыЭД", ПараметрыФормыЭД);
			ПараметрыФормы.Вставить("РежимСправкаПоШаблону", Истина);
			ПараметрыФормы.Вставить("ИмяШаблона", Контекст.ИмяШаблона);
			ИнтерфейсДокументовЭДОУТКлиент.ПоказатьСправкуПоФорматуДоговорногоДокумента(ДобавленныйФайл, ПараметрыФормы);
		Иначе
			ИнтерфейсДокументовЭДОУТКлиент.ПоказатьСправкуПоФорматуДоговорногоДокумента(ДобавленныйФайл, ПараметрыФормыЭД);
		КонецЕсли;
		// Конец ЭлектронноеВзаимодействие.ОбменСКонтрагентами
		
	КонецЕсли; 			

КонецПроцедуры 

&НаСервере
Функция ПолучитьРезультатФоновогоЗадания(Результат)
	
	РезультатФоновойОперации = ПолучитьИзВременногоХранилища(Результат.АдресРезультата);
	
	Если ТипЗнч(РезультатФоновойОперации) = Тип("Структура") Тогда		
		ТаблицаПечатныхФорм = РезультатФоновойОперации.КоллекцияПечатныхФорм;
		ОфисныеДокументы = РезультатФоновойОперации.ОфисныеДокументы;
		ОбъектыПечати = РезультатФоновойОперации.ОбъектыПечати;
		
		Для Каждого ПечатнаяФорма Из ТаблицаПечатныхФорм Цикл
			ОфисныеДокументыНовыеАдреса = Новый Соответствие();
			Если ЗначениеЗаполнено(ПечатнаяФорма.ОфисныеДокументы) Тогда
				Для Каждого ОфисныйДокумент Из ПечатнаяФорма.ОфисныеДокументы Цикл
					ОфисныеДокументыНовыеАдреса.Вставить(ПоместитьВоВременноеХранилище(ОфисныеДокументы[ОфисныйДокумент.Ключ], УникальныйИдентификаторХранилища), ОфисныйДокумент.Значение);
				КонецЦикла;
				ПечатнаяФорма.ОфисныеДокументы = ОфисныеДокументыНовыеАдреса;
			КонецЕсли;
		КонецЦикла;
		СтруктураРезультата = Новый Структура("КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода");
		СтруктураРезультата.КоллекцияПечатныхФорм = ТаблицаПечатныхФорм;
		СтруктураРезультата.ОбъектыПечати = ОбъектыПечати;
		СтруктураРезультата.ПараметрыВывода = РезультатФоновойОперации.ПараметрыВывода;
		
		Возврат СтруктураРезультата;
	Иначе		
		ДобавленныйФайлСтруктура = Новый Структура("ИмяФайла, ДвоичныеДанные");
		ДобавленныйФайлСтруктура.ИмяФайла = РезультатФоновойОперации[0].ИмяФайла;
		ДобавленныйФайлСтруктура.ДвоичныеДанные = РезультатФоновойОперации[0].ДвоичныеДанные;  
	
		Возврат ДобавленныйФайлСтруктура;   
	КонецЕсли;
	
КонецФункции

&НаСервере
Функция ПараметрыОткрытияФормыПечати()
	ПараметрыОткрытия = Новый Структура("ИмяМенеджераПечати,ИменаМакетов,ПараметрКоманды,ПараметрыПечати,УникальныйИдентификаторХранилища,
	|ИсточникДанных,КоллекцияПечатныхФорм,ПараметрыИсточника,ТекущийЯзык,ВладелецФормы,ПараметрыВывода");
	ПараметрыОткрытия.Вставить("ОбъектыПечати", Новый СписокЗначений);
	Возврат ПараметрыОткрытия;
КонецФункции  

&НаКлиенте
Функция ПараметрыОжидания()
	
	ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтотОбъект.ВладелецФормы);
	ПараметрыОжидания.ТекстСообщения = НСтр("ru = 'Подготовка печатных форм.'");
	ПараметрыОжидания.ОповещениеПользователя.Показать = Ложь;
	ПараметрыОжидания.ВыводитьОкноОжидания = Истина;
	ПараметрыОжидания.Интервал = 0;
	ПараметрыОжидания.ВыводитьСообщения = Ложь;
	Возврат ПараметрыОжидания;

КонецФункции

// Параметры:
//  ПараметрыПодготовки - см. ПараметрыПодготовкиФайла
//
&НаКлиенте
Процедура ЗапроситьИПодготовитьФайл(ПараметрыПодготовки) Экспорт // АПК:78 - исключение для вызова клиентских методов.
	
	// ЭлектронноеВзаимодействие.ОбменСКонтрагентами
	ИнтерфейсДокументовЭДОУТКлиент.ЗапроситьФайлПДФ_А3(ПараметрыПодготовки.Данные);
	// Конец ЭлектронноеВзаимодействие.ОбменСКонтрагентами
		
КонецПроцедуры

// Процедура-"заглушка", для возможности переопределения формы выбора файла договорного документа
&НаКлиенте
Процедура ЗагрузитьИзФайлаЗавершение(ПомещенныйФайл, ПараметрыФормы) Экспорт // АПК:78 - исключение для вызова клиентских методов.
		
	Возврат;
	
КонецПроцедуры

// Процедура-"заглушка", для возможности переопределения формы выбора файла договорного документа
&НаКлиенте
Процедура ЗапроситьФайлЗавершение(ПомещенныйФайл, ПараметрыФормы) Экспорт // АПК:78 - исключение для вызова клиентских методов.
		
	Возврат;
	
КонецПроцедуры

// Возвращаемое значение:
//  Структура:
//   * ОбработчикЗавершения - Неопределено - Значение по умолчанию
//                          - ОписаниеОповещения - Обработчик, который будет вызван после подготовки файла
//   * Данные               - Неопределено - значение по умолчанию.
//                          - ОпределяемыйТип.ОснованияЭлектронныхДокументовЭДО - объект, к которому готовится файл.
//                          - Структура:
//                            * ОбъектУчета - ОпределяемыйТип.ОснованияЭлектронныхДокументовЭДО - объект, к которому
//                                                                                                готовится файл.
//
&НаКлиенте
Функция ПараметрыПодготовкиФайла() Экспорт // АПК:78 - исключение для вызова клиентских методов.
	
	ПараметрыПодготовки = Новый Структура;
	ПараметрыПодготовки.Вставить("ОбработчикЗавершения", Неопределено);
	ПараметрыПодготовки.Вставить("Данные",               Неопределено);
	
	Возврат ПараметрыПодготовки;
	
КонецФункции

#КонецОбласти 
